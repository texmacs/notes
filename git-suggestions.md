# A few suggestions for using `git`

## Conflicts

It can happen that conflicts between the local copy of the repository and the "upstream" remote repository at `https://github.com/texmacs/notes.git` prevent pulling in the upstream changes. For example, `git` could answer a `merge upstream/main` command with 

```
error: Your local changes to the following files would be overwritten by merge:...
Merge with streategy ort failed.
```
where the ellipsis represents further `git` output.

One might solve the conflicts one-by-one using _exempli gratia_ `mergetool`, but this can be slow (slower than one wants).
Here are two possible ways to respectively go around the conflicts or solve (perhaps in a strong-handed way) them.

  * Go around the whole conflict by starting with a "clean" repository
      * Save the articles you are working on somewhere else
      * Make a new clone of the repository (one can have as many clones of a remote repository as they like)
      * Add to it your articles, push the changes to your remote repository, send a pull request to upstream
  * Solve all conflicts at once by merging the upstream repository with the strategy _option_ `theirs` (on the _strategy_ `ort`)
      * `git merge --strategy-option theirs`
      * With this strategy option, all of the conflicts will be solved in favour of the upstream version of the repository. From our point of view, before merging we make sure that all of the changes that we want to apply are in parts of the repository that do not conflict with upstream; for example we add one article: since the article does not exist in the upstream repository, it does not conflict and will remain in our local repository with the merged upstream changes
      * See https://stackoverflow.com/questions/10697463/resolve-git-merge-conflicts-in-favor-of-their-changes-during-a-pull and answer https://stackoverflow.com/a/10697551
      * Note that strategy  _options_ are applied on top of strategies; so with the strategy option`theirs` we are modifying the behaviour of the `ort` strategy (which we did not specify because it is the default one)
      * From `git help merge`
```
The ort strategy can take the following options:

           ours
               This option forces conflicting hunks to be auto-resolved
               cleanly by favoring our version. Changes from the other tree
               that do not conflict with our side are reflected in the merge
               result. For a binary file, the entire contents are taken from
               our side.

               This should not be confused with the ours merge strategy, which
               does not even look at what the other tree contains at all. It
               discards everything the other tree did, declaring our history
               contains all that happened in it.

           theirs
               This is the opposite of ours; note that, unlike ours, there is
               no theirs merge strategy to confuse this merge option with.

```
      * Of course, if we changed a file that also got changed upstream in a conflicting way, _and we want to keep our changes_, then we should not apply the strategy option `theirs`, but solve the conflicts by hand


After merging the upstream repository with the local one, conflicts can appear when pushing one's changes onto one's personal _remote_ version of the repo. The error `git` reports is

```
error: failed to push some refs to <your remote repository address here> hint: Updates were rejected because the tip of your current branch is behind hint: its remote counterpart.
```

Here, if one is happy with their own local version of the repo, a strong-handed action can help: force one's own remote repository to the local version with

```
git push origin <your_branch_name> --force
```

See https://stackoverflow.com/questions/5509543/how-do-i-properly-force-a-git-push for several discussions on the topic (when reading Stackoverflow answers, one should keep in mind that some of them may be incorrect or inappropriate for one's issue).
If you share the remote repository with someone else, you should of course make sure that they agree with overwriting your changes onto it (your `--force`).