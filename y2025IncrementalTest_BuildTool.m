%% 
% Alright! I'm back after a mid-series break to continue our talk about
% incremental testing. 
%
% In parts 1 and 2, we looked at interactive development workflows to help
% run the right set of tests at the right time. In this post, we'll look at
% how that idea extends to automated builds using the MATLAB build tool,
% and specifically, how incremental testing enables faster local
% prequalification. The motivation remains the same – to enable frequent,
% high-quality integrations verified by automated builds, without incurring
% the overhead of running the full regression suite after every change.
%
% Running all the tests might be manageable at small scale but it quickly
% becomes prohibitively expensive for larger projects.
%
% *Info:* This post assumes that you are somewhat familiar with the
%         <https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%         MATLAB build tool> . If not, you can get an overview here. It
%         provides a uniform and standardized way to define and run
%         MATLAB builds.
%
%% What Is Incremental Testing?
% The MATLAB build tool supports
% <https://www.mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html
% incremental builds>, which skips unnecessary work by tracking each build
% task's inputs, outputs, actions and arguments to determine if the task is
% up-to-date. If nothing has changed since its last successful run, the
% task is skipped.
% 
% Starting with R2025a, it enhances this capability with incremental
% testing, available with MATLAB Test. While incremental build determines
% whether a task should rerun, incremental testing goes further – it uses
% test impact analysis to decide which tests need to run. This can
% significantly optimize test execution and speed up your builds
%
% With incremental testing enabled, the build tool analyzes the source and
% test code changes and runs only tests impacted by those changes. 
% 
% Let's unpack how this works. We'll start with some basics.
%
%% Background
% We'll use the same goal as in Part 2 – enhancing the AND perceptron to
% introduce a trainable bias term. The exact goal isn't critical; it's just
% a useful backdrop.
%
%%% Defining the Build
% A |buildfile.m| at the project root defines your MATLAB build.
% 
% <<buildfile_location.png>>
%
% This build file creates a plan that describes how to build the project –
% it defines a set of build tasks and their dependencies to establish a
% task graph to execute with a single
% <https://www.mathworks.com/help/matlab/ref/buildtool.html buildtool>
% command.
% 
% <include>before/buildfile.m</include>
%
% In our example, the build file includes:
%   * A |test| task to run tests
%   * A |clean| task to delete task outputs and traces
%
% These tasks are created using the
% <https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks-package.html
% built-in task classes> . Built-in task classes streamline the creation of
% standard tasks like identifying code issues, building MEX binaries and
% testing. The built-in task classes are designed for reuse and generally
% support
% <https://www.mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html
% incremental build> out of the box.
%
% Out |test| tasks uses the
% <https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html
% matlab.buildtool.tasks.TestTask> class, which runs tests using the MATLAB
% Unit Testing Framework.
%
%%% Optimizing Performance with Incremental Build
% Before diving into incremental testing, let's briefly look at how
% incremental build works. 
%
% When we first clone our repository, the build tool has no task traces.
%
% *Info:* A *task trace* is a record of a task's inputs, outputs,
%         actions and arguments from its last successful run. 
%
% So, when we run the |test| task, it runs because there are no traces yet,
% and runs *all* the tests defined by the task. 
%
% <<run_with_no_task_trace.png>>
%
% ...
%
% <<test_run_summary_no_task_trace.png>>
%
% This is nice because it gives us confidence that the repository is in a
% known-good state before making any code changes. 
%
% The build tool creates a |.buildtool| cache folder in the project root
% folder to store the task traces.
%
% <<task_trace_folder.png>>
%
% On subsequent builds, if nothing has changed, the task is skipped.  
%
% <<skipped_task.png>>
%
% Now, let's say we modify a source file like |initializeWeights.m|, and
% re-run the build.
%
% <<sample_change_source_control.png>>
%
% Since this file is tracked via the |SourceFiles| property, one of the
% task inputs of the test task that the build tool tracks as part of
% <https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html#mw_96cca6ff-6c81-4dd9-87d2-5c7df47b475b
% up-to-date check>, the tool recognizes the changes and re-runs the task.
%
% <<rerun_after_sample_change.png>>
%
% Nice! But do we really need to run all the tests for that single source
% file change? Wouldn't it be better if just the impacted tests ran. That's
% exactly what incremental testing in R2025a delivers.
%
%% Enabling Incremental Testing
% So, how do we get the incremental testing behavior? 
% 
% Incremental testing is powered by test impact analysis. To enable it, you
% can simply run the |test| task with the |RunOnlyImpactedTests| task
% argument.
%
%   >> buildtool test(RunOnlyImpactedTests=1)
%
% Let's look at an example. Say we change |initializeWeights.m| and
% |calculateWeightedSum.m| as part of our perceptron enhancement, like we
% did in Part 2:
%
% *initializeWeights.m*
% 
% <html><u>Before:</u></html>
% 
% <include>before/toolbox/initializeWeights.m</include>
% 
% <html><u>After:</u></html>
% 
% <include>after/toolbox/initializeWeights.m</include>
%
% *calculateWeightedSum.m*
% 
% <html><u>Before:</u></html>
% 
% <include>before/toolbox/calculateWeightedSum.m</include>
% 
% <html><u>After:</u></html>
% 
% <include>after/toolbox/calculateWeightedSum.m</include>
%
% When you set |RunOnlyImpactedTests| to |true|, the |test| task analyzes
% those changes and runs only the impacted tests. Look at that!
%
% <<run_impacted_tests.png>>
%
% Behind the scenes, the build tool tracks changes to the source and test
% files of the |test| task created using the the built-in |TestTask| class
% (more on this later in the post).
%
% When |RunOnlyImpactedTests| is true, the |test| task doesn't just detect
% that the files changed – it determines which tests are impacted by those
% changes and runs only those.
%
% Increasing the build verbosity to level 3 (Detailed) or higher reveals
% which changes triggered the task execution. In our example, we see that
% the |SourceFiles| property has changed because |initializeWeights.m| and
% |calculateWeightedSum.m| were modified.
%
% As seen in Part 2, changes to just those two files do not meet the goal.
% The diagnostics will reflect this.
%
% <<run_impacted_tests_failures.png>>
%
% Let's fix the rest of the code base like we did in Part 2 to ensure we
% have all the necessary changes and rerun the build with incremental
% testing.
%
% _After some coding and a cup of coffee..._ 
%
% <<rerun_impacted_tests.png>>
%
% Success! The build passes and we ran just the related tests. 
%
% <<run_impacted_tests_success.png>>
%
% Our toy example had just 5 tests, but real-world projects can have
% hundreds or thousands – so the potential for performance gain is
% substantial.
%
% To avoid the need to specify the task argument every time, we can
% configure the test task in your |buildfile.m| to always run only impacted
% tests by default.
%
% <<buildfile_roit.png>>
%
% Then at run time, we can specify just "test". 
%
%   >> buildtool test
%
% You can toggle the |RunOnlyImpactedTests| option at run time or create
% separate test tasks with and without incremental testing to match your
% workflow preferences.
%
%% A Closer Look at Impact-Based Testing
%
% Impact-based testing involves two key concepts:
% 
% * Change Detection refers exclusively to the concern of detecting changes
% to the task's tracked files
% * Impact Analysis refers exclusively to the concern of analyzing the
% impact of those changes.
%
% *Change Detection*
% When you enable test impact analysis, the |TestTask| detects changes to
% source files, supporting files and tests as defined by the task's
% |SourceFiles|, |SupportingFiles|, and |Tests| properties. It also tracks test
% class folders and test superclasses. 
% 
% But what is the change window? … It's changes _since the last successful
% run_. 
% 
% A picture might help… it always goes a long way for me.
%
% <<change_window.png>>
% 
% For example, let's suppose you have a successful build, *b_1*. After you
% make a change *C1*, and run the build, the build tool checks for changes
% in source, supporting, and test files since *b_1*. If *C1* causes a
% regression and *b_2* fails, the next build, *b_3* still uses *b_1* as the
% reference point - because it's the last successful run. This ensures the
% integrity of your commits and code integration.
%
% Only files that are _added_ or _modified_ are considered  for impact
% analysis; _removed_ files are not. If you're using MATLAB projects,
% removing a file triggers dependency analysis to help you identify which
% files are affected so you action appropriately and clean up cruft and
% dead code.
% 
% In summary, change detection:
%   * Detects files defined by the |SourceFiles|, |SupportingFiles| and
%   |Tests| properties of the |test| task.
%   * Detects files that are either _added_ or _modified_.
%   * Detects changes since the last successful task run.
% 
% *Impact Analysis*
% Like the *Find Tests* (Part 1) feature in the Editor and *Impacted Tests
% Since Last Commit* option (Part 2) in the MATLAB test manager app, the
% TestTask also uses
% <https://www.mathworks.com/help/matlab/ref/dependencyanalyzer-app.html#mw_16e23e55-ae1c-4228-8f5f-97273d840a70
% dependency analysis> to find impacted tests. It uses it via the
% <https://www.mathworks.com/help/matlab-test/ref/matlabtest.selectors.dependson-class.html
% DependsOn> test selector, which, in R2025a, enhanced the accuracy of test
% selection with the ability to select individual tests within a test file.
%
% > *Important Reminder:* Static analysis isn't perfect. It has
% <https://www.mathworks.com/help/matlab/ref/dependencyanalyzer-app.html#mw_16e23e55-ae1c-4228-8f5f-97273d840a70
% limitations> . Use incremental testing with vigilance and discipline –
% *trust but verify*. Always run the full test suite at key points in your
% release cycle to ensure complete coverage and confidence.
%
%% Interaction Between Incremental Build and Incremental Testing
%
% Earlier, I mentioned that if a task's inputs, outputs, actions and
% arguments haven't changed since the last successful run, the build tool
% skips the task. This applies to the |RunOnlyImpactedTests| option as well
% since that is also an input of the |TestTask|.
%
% <<skipped_task_roit.png>>
%
% When you rerun the test task with the same |RunOnlyImpactedTests| value
% and the task has no other changes either, the build tool skips the task.
% Why? 'cuz of Incremental Build!
%
% *Quiz Time!*
%
% Suppose you change the |TestResults| task output property:
%
% From:
%
%   plan("test") = TestTask("tests", SourceFiles="toolbox", TestResults="results/test-results.xml");
%
% To:
%
%   plan("test") = TestTask("tests", SourceFiles="toolbox", TestResults="results/test-results.html");
%
% *Question:* What tests will run if |RunOnlyImpactedTests| is set to
% |true|, assuming the above |buildfile.m| is the only change made in your
% project since the last successful run and no other changes?
%
% Let us know what you think in the comments!
%
% *Bonus Credit*
%
% In |buildfile.m|,
% <https://www.mathworks.com/help/matlab/ref/matlab.buildtool.task-class.html?searchHighlight=DisableIncremental&s_tid=srchtitle_support_results_2_DisableIncremental
% disable incremental build>:
%
%   plan("test") = TestTask("tests", SourceFiles="toolbox", TestResults="results/test-results.xml");
%   plan("test").DisableIncremental = 1;
% 
% Then run:
%
%   >> buildtool test(RunOnlyImpactedTests=1)
%
% *Question:* What tests do you expect to run? And why? Share your thoughts
% in the comments. 
%
%% Summary
% There you have it! Incremental testing with the MATLAB Build Tool and
% MATLAB Test can greatly improve the efficiency of automated builds,
% locally and in CI, by running only the tests impacted by recent changes.
% It complements interactive development and helps reduce test times
% without sacrificing coverage.
% 
% While static dependency analysis has limitations, incremental
% testing can deliver substantial value with some user awareness and
% discipline. 
% 
% This post focused on local builds, but the same benefits
% apply to CI environment as well – we'll dive into that in the next part!
%
% _Would you consider using incremental testing in your workflows?
% What challenges do you foresee? Are there gaps in change detection or
% impact analysis that MathWorks could address to help you trust
% incremental testing more? We'd love to hear your thoughts – share them in
% the comments section below!_
