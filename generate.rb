#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'builder'

def api(request)
  cmd = "curl -s -u \"#{@creds['username']}:#{@creds['password']}\" https://api.github.com"
  d = "#{cmd}#{request}"
  puts "--> Issuing: #{request}"
  JSON.parse(`#{d}`)
end

def type_of_collection(name) 
  ctype = ""
  usr = api("/users/#{name}/repos")
  ctype = "users" if usr.class == Array && usr.size > 0
  org = api("/orgs/#{name}/repos")
  ctype = "orgs"  if org.class == Array && org.size > 0
  puts "--> Couldn't find collection: #{name}" if ctype == ""
  ctype
end

def validated_branches(collection_name, repo_name, branches)
  branches ||= ["master"]
  list_of_branches = api("/repos/#{collection_name}/#{repo_name}/branches")

  if branches == "all" || branches == ["all"]  # "all" ... every valid branch
    valid_branches = list_of_branches
  else
    valid_branches = list_of_branches.select { |b| branches.include?(b['name']) }
  end
  valid_branches
end

def run(input_file, output_file)

  yml = YAML::load(File.open(input_file))
  @creds = yml["credentials"]
  @collections = yml["collections"]

  xml = Builder::XmlMarkup.new(:indent => 2)
  xml.instruct!

  xml.opml(:version => 1.1) do
    xml.head do
      xml.title "Github RSS subscriptions for #{@creds['username']}"
      xml.dateCreated Time.now.httpdate
    end
    xml.body do
      @collections.each do |collection|
        cname = collection['name']
        ctype = type_of_collection(cname)
        next if ctype == ""   # no such collections

        xml.outline(:title => cname,:text => cname) do
          repos = api("/#{ctype}/#{cname}/repos")
          repos.each do |repo|
            branches = validated_branches(cname, repo['name'], collection['branches'])
            branches.each do |branch|
              xml.outline({
                :type => 'rss',
                :version => 'RSS',
                :title => "#{repo['name']} - #{branch['name']}",
                :text => repo["description"],        
                :description => repo["description"],
                :htmlUrl => repo["html_url"],
                :xmlUrl => "#{repo['html_url']}/commits/#{branch['name']}.atom?login=#{@creds['username']}&token=#{@creds['apitoken']}"
              })
            end
          end
        end

      end
    end

  end

  puts "--> Writing to file"
  File.open(output_file, 'w') { |f| f.write(xml.target!) }
end


abort "Usage: ./generate.rb <YAML input file> <Output filename>" if ARGV.size != 2
  
run(ARGV[0], ARGV[1])
