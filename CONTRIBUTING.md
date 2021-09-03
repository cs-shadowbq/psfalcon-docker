# How to contribute

I'm really glad you're reading this, because we need volunteer developers to help this project come to fruition.

Here are some important resources:

* [CrowdStrike](http://crowdstrike.com) Official CrowdStrike Website
* [PSFalcon](https://github.com/CrowdStrike/psfalcon) Official Powershell module for client API access

## Testing

We have a handful of Bash tests, but lack robust testing at this time.

## Submitting changes

Please send a [GitHub Pull Request to psfalcon-docker](https://github.com/cs-shadowbq/opengovernment/pull/new/main) with a clear list of what you've done (read more about [pull requests](http://help.github.com/pull-requests/)). When you send a pull request, we will love you forever if you include test examples. We can always use more test coverage. Please follow our coding conventions (below) and make sure all of your commits are atomic (one feature per commit).

Always write a clear log message for your commits. One-line messages are fine for small changes, but bigger changes should look like this:

    $ git commit -m "A brief summary of the commit
    > 
    > A paragraph describing what changed and its impact."

## Coding conventions

Start reading our code and you'll get the hang of it. We optimize for readability:

* We indent using four spaces (soft tabs)
* We use Bash 3.x compliant, or wrappers for MacOS development.
* Dockerfiles should use `org.opencontainers.image` complaint tags.
* This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
