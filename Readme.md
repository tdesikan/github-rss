# Github-RSS

I wanted to follow a bunch of (50+) GitHub repos via my favorite RSS reader. 

You can easily set up an RSS feed using this syntax:

    https://github.com/username/repository_name/commits/branch_name.atom?login=login&token=token

However, adding each repo & branch manually is a pain.

### So, presenting ... Github-RSS.

I use the [GitHub APIs](http://developer.github.com/) to create an [OPML file](http://support.google.com/reader/bin/answer.py?hl=en&answer=70572) that most RSS readers can understand.


# Usage

In a YAML file, specify your credentials and details of the users / organizations whose repos you wish to follow. See `example.yaml`.

Then run:

    ./generate.rb example.yaml output.xml

`output.xml` is your OPML file. Use your RSS reader's import feature to add all the GitHub feeds listed in `output.xml`.

You can manually edit the OPML file to remove repos / branches you don't want.
