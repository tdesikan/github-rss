# Github-RSS

I wanted to follow a bunch of (50+) GitHub repos via my favorite RSS reader. 

You can easily set up an RSS feed using this syntax:

    https://github.com/username/repository_name/commits/branch_name.atom?login=login&token=token

However, adding each repo & branch manually was a pain.

### So, presenting ... Github-RSS.


# Usage

In a YAML file, specify your credentials and details of the repos you wish to follow. See `example.yaml`.

Then run:

    ./generate.rb example.yaml output.xml

`output.xml` is an OPML file that every RSS reader should be able to import.

