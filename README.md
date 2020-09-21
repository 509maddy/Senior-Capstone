# Senior-Capstone

## Git Cheat Sheet
-[Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

## Our Branches
1. `master` branch will hold the code that was demonstated at our latest "progress report"
    - Should always build and run successfully
1. `develop` branch is what we are working on since our latest "progress report"
    - Never directly modify this branch
    - Should always build and run successfully
1. Feature branches are used to add/modify individual features.
    - Find a task from [the project scrum board](https://github.com/509maddy/Senior-Capstone/projects/1)
    - Create branch from `develop`, name your branch `task_number-description`
    - Next, make your changes to this branch
    - Create a pull request to merge your feature branch into develop. If there are merge conflicts you need to fix them (we are willing to help if needed). 
    - Someone else accept the PR. This way we have another set of eyes on the code.
    - After the PR is accepted, the creator of the branch needs to merge and delete their branch.
