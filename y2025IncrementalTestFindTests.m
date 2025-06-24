%% 
% Imagine you are developing an application and writing code in your MATLAB
% development environment.
% 
% Code changes, even small ones, can introduce unintended consequences in
% complex software systems. Running an entire test suite to validate every
% change slows down feedback loops and reduces development efficiency. For
% new contributors, unfamiliarity with the codebase further amplifies this
% challenge, making it harder to identify which tests are relevant.
% 
% When you make code changes, your focus is usually on a specific file. You
% want to iterate swiftly and confidently without losing context. To
% streamline this just-in-time validation process, *MATLAB Test R2025a*
% integrates dependency-based test impact analysis directly in the MATLAB
% Editor. This makes it easier to find and run only the tests related to
% the file you are actively working on.
% 
% At the heart of this is the new |Find Tests| button on the MATLAB
% Toolstrip that shows up if you have the MATLAB Test toolbox. MATLAB
% easily analyzes dependencies for the open file and identifies relevant
% tests. These are automatically populated in the Test Browser, so you can
% run just those necessary tests without ever leaving the Editor or
% searching manually through your project.
% 
% While impact-based testing shines brightest in large projects, let's take
% a simple example to see how it works in practice. When using static
% analysis, there are likely many nuances and limitations to detecting the
% impact without any gaps. See
% <https://blogs.mathworks.com/developer/2023/10/26/dependency-based-test-selection/
% Dependency-based Test Selection>.
% 
%% Example: Testing a Simple Perceptron
% *Setup*
% Our example here is a simple neural network,
% <https://www.codecademy.com/learn/perceptrons-and-neural-nets-skill-path/modules/perceptrons-skill-path/cheatsheet
% perceptron> , that creates a binary linear classification model that
% simulates the task of decision making. You don't need to fully understand
% the details of how it works; in fact, it's better if you don't. Like the
% scenario of a new contributor unfamiliar with the codebase, this lets you
% see how the |Find Tests| feature helps you identify which tests are
% relevant, without having to reverse-engineer everything first.
% 
% <<project_setup.png>>
% 
% The project has some source code and tests. The main goal of a perceptron
% is to make accurate classifications. This is achieved through optimizing
% the weights of the perceptron so the model can be better trained. We
% start off by calculating the weighted sum and that is used to train the
% model and use the trained model for prediction.
% 
% *Let's make a change*
% Say, you are interested in determining how changes to the initialization
% of weights affect the classifier's performance. So, you open the
% initializeWeights.m file in the MATLAB Editor.
% 
% <<initializeWeights_before.png>>
% 
% You change the scaling factor from 0.1 to 0.5 and want to validate the
% change. Luckily the project has tests. In this case, there's only a
% handful of them, but you are not sure if all of them are relevant to this
% file and change, and how long it would take to run them all. You want
% your iterations to be quick. The new |Find Tests| button to the rescue!
% 
% <<initializeWeights_after.png>>
% 
% When you click the |Find Tests| button, it prompts you to choose the
% folder where tests are located. It runs MATLAB dependency analysis and
% populates the
% <https://www.mathworks.com/help/matlab/ref/testbrowser-app.html |Test
% Browser|> app with just those related tests.
% 
% <<testbrowser_related_tests.png>>
% 
% Now you can interact with the |Test Browser| as you normally would. Click
% the |Run Tests| button to run the test suite and see how your changes
% impact the perceptron performance. Hmm, changing the scaling factor to
% 0.5 didn't seem to have much impact. Perhaps that is because this is a
% simple AND perceptron. But that tighter, faster feedback loop gives you
% confidence to keep experimenting or moving forward with the change.
% 
% <<testbrowser_related_tests_run.png>>
% 
%% Stay Focused. Stay In Context. 
% When you're editing a file, that file is your primary focus. Everything
% else can be noisy. |Find Tests| optimizes for that mental context by
% populating just the relevant tests in a clean |Test Browser|, reducing
% distraction and cognitive load.
% 
% You can also then enable coverage collection in the |Test Browser| to see
% which parts of your modified or new code are exercised by existing tests.
% This helps you identify and close coverage gaps before pushing your
% changes. (The |Generate Tests| button right next to |Find Tests| can also
% help here.)
% 
%% Key Considerations 
% Test impact analysis is only as effective as our test coverage. If there
% are no tests or not enough tests in the project, there's little to
% analyze and benefit from. The richer the test suite, the better the
% outcome from test impact analysis. The better the test impact analysis,
% the better the confidence in making code changes.
% 
% |Find Tests| determines dependencies (a.k.a. impact) with static analysis,
% and like any static analysis technique, it has limitations. It's not
% perfect or exhaustive. Think of it as a performance optimization that
% benefits from user vigilance − trust but verify. It is still recommended
% to run your full test suite at key stages in your development and release
% cycle. Check out the Dependency-based Test Selection blog post for more
% insights. 
%
%       *Tip*: If you know of a test that needs to run due to an untracked
%       dependency you can still manually add it via the |Test Browser|
%       after you "find the tests".
% 
%% In Summary...
% You can find impacted tests manually, but by surfacing the relevant tests
% just at the right time, MATLAB Test's |Find Tests| reduces the cognitive
% load, time and effort required to validate changes—especially in large
% projects with extensive test suites—and provides immediate guidance for
% new contributors or when working in unfamiliar areas of the codebase.
% Ultimately, it helps maintain high confidence in code changes while
% accelerating development workflows.
% 
% How do you see this feature helping your day-to-day development
% workflows? What other tools or capabilities would you like to see
% integrated more tightly with |Find Tests| and the Editor to further
% assist you in completing your workflows without having to switch too many
% contexts? What else do you see valuable for a more rigorous test impact
% analysis?
% 
% Let us know in the comments!
