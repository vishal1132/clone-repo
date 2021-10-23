## Clone all the repositories from your organization,
If you are changing your machine and need to clone all of your repositories again in the new machine, you can try using this.
It works only for github though and you will have to acquire a personal access token for your github account, and pass it as a command line flag.

The basic usage is- 
```
ruby gihtub.rb -o <org> -t <token> -n <num-repos>
```

num-repos is the total number of repos in your organization, since github api limits querying repos 100 per page.