%% 
% In the <https://blogs.mathworks.com/developer/2025/08/20/tldr-too-long-didnt-run-part-3-incremental-testing-with-the-matlab-build-tool/ previous post> we explored how to use the MATLAB build tool to run only impacted tests
% during local, iterative development cycles. In this post, we'll take that
% concept further and apply incremental testing in a continuous integration
% (CI) environment to speed up feedback and improve overall throughput.
% 
%% Example Project: _arithmetic_ 
% For this walkthrough, we'll use a simple example project,
% _arithmetic_, that contains:
% 
% * MATLAB functions for basic arithmetic operations.
% * Unit tests for those functions. 
%
% *Project Structure:* 
% 
% <<2025-tia-ci-project-structure.png>>
%
% The |toolbox| folder holds the source code, while the |tests| folder 
% contains tests for those functions.
% 
%% Context
% Whether (and when) you choose to run only impacted tests versus the full
% test suite depends on many factors, including:
% 
% * Project complexity
% * Branching strategy
% * Release cadence and workflow
% * Team or organizational standards
%
% This post does not prescribe a software qualification strategy. Instead,
% it shows an example on how to achieve incremental testing in CI using the
% build tool's _test impact analysis_ .
% 
% For this example, we'll configure the build to run incremental tests on
% *feature branches* whenever a developer pushes changes. The same
% approach, however, can be adapted to other events such as pull requests,
% merges to |main| , or nightly builds.
% 
% I'll demonstrate this example using *GitHub Actions*, but this pattern is
% easily transferable to other CI systems like GitLab CI, Azure DevOps or
% Jenkins.
%
%% The Build File
% The |buildfile.m| in the project defines a build plan with a |test| task
% that runs the project's tests and produces results.
% 
% <include>buildfile.m</include>
%
% Incremental testing is enabled by setting |RunOnlyImpactedTests| property
% or task argument to true on a TestTask instance. In this example, we will
% use the task argument at runtime, rather than baking it directly into the
% |test| task configuration.
% 
% As discussed in the previous post, the build tool stores task traces in
% the |.buildtool| cache folder. A *task trace* is a MATLAB
% release-specific record of a task's inputs, outputs, actions and
% arguments from its last successful run.
% 
% By caching and restoring these task traces (and outputs such as test
% results) in CI, we can effectiely enable the build tool to detect changes
% and run only impacted tests in CI workflows as well. 
% 
%% CI Pipeline Configuration
% The GitHub Actions workflow configuration is defined in
% |.github/workflows/ci.yml|:
% 
% <include>.github/workflows/ci.yml</include>
% 
% The configuration has the following key steps:
% 
% * Setup MATLAB
% Installs MATLAB R2025a including MATLAB Test using the MathWorks'
% official <https://github.com/matlab-actions/setup-matlab matlab-actions/setup-matlab> action. 
% 
% * Setup Caching 
% Cache and restore the |.buildtool| folder and |results/| directory. The
% cache key, in this example, includes the OS and branch name (e.g.,
% Linux-buildtool-cache-feature/cache). See
% <https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching#cache-action-usage
% GitHub Actions cache action usage> for more information on how to use
% cache action and how key matching works.
% 
% * Run MATLAB
% Uses <https://github.com/matlab-actions/run-build
% matlab-actions/run-build> to execute the test task with
% RunOnlyImpactedTests=true to run only impacted tests. 
% 
%% First Run (No Cache)
% Let's create a feature branch |feature/cache| under this blog's branch
% |2025-Test-Impact-Analysis-CI|. 
% 
% On the first pipeline run, there is no cache hit for key
% |Linux-buildtool-cache-feature/cache|.
% 
% <<2025-tia-ci-first-run-cache-miss.png>>
% 
% All tests run because no prior traces exist:
% <<2025-tia-ci-first-run-all-tests.png>>
% 
% The pipeline then creates and saves a cache for future runs:
% <<2025-tia-ci-first-run-cache.png>>
% 
% <<created_cache>>
% 
%% Second Run: Modify |h_my_add.m|
% Let's make a change. 
%
% * Clone the repository at branch |2025-Test-Impact-Analysis-CI|. 
% * Run the build locally with |buildtool|. 
% ** On the first run, all the tests run (no task traces yet).
%   
% Next, checkout and switch to the |feature/cache| branch, then modify
% |h_my_add.m|, say, by adding an arguments block:
% 
% <include>toolbox/h_my_add.m</include>
% 
% Verify locally with:
% 
%   >> buildtool test(RunOnlyImpactedTests=1) -verbosity 3
% 
% *Tip:* Run the build at verbosity 3 or higher to see exactly what has
%        changed and why the task is re-running.
% 
% *Output (excerpt)* :
% 
% <<2025-tia-ci-second-run-local.png>>
% 
% Only 8 out of 21 tests were selected to run—those impacted by the
% modified file. That's promising!
% 
% Now let's push the changes and inspect the CI pipeline.
% 
% <<2025-tia-ci-feature-push-trigger.png>>
% 
% Cache hit confirms the |.buildtool| and |results| folder were restored. 
% 
% <<2025-tia-ci-feature-cache-hit.png>>
% 
% The build tool leverages the restored cache to run only impacted tests.
% 
% <<2025-tia-ci-feature-cache-run-build.png>>
% 
%% Third Run: Modify |my_subtract.m|
% Make another change, commit, and push. The cache is restored again, and
% now only the tests impacted by both outstanding changes on the feature
% branch are executed:
% 
% <<2025-tia-ci-third-run-cache-hit.png>>
% 
% <<2025-tia-ci-third-run-impacted-tests.png>>
%
%% Wrapping Up
% There you have it! This workflow demonstrates how to combine:
% * MATLAB build tool's test impact analysis
% * CI platform's caching
% 
% ... to achieve incremental testing in CI. 
% 
% You can refine this pattern by adding things like:
% * Adding cache restore keys to support fallback scenarios.
% * Adjusting cache keys for multi-platform or multi-branch setups.
% * Deciding when to run incremental tests vs. full regression tests.
% 
% Would you run incremental testing in your CI pipeline? At what point in
% your release cycle do you feel most comfortable running only impacted
% tests?
%
% We anticipate investing in improving incremental testing across both
% local and CI workflows. Your feedback will help us prioritize what
% matters most to you.
% 
% That's a wrap (for now) for this series on *Test Impact Analysis* but
% stay tuned, we are lining up more software development topics to bring to
% you!
