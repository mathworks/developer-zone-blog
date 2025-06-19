%%
% Hello everyone, it has been a long time! I am excited to resurrect the
% conversation a bit here because we have a number of topics that are in
% the pipeline. Actually, there have always been plenty of topics in the
% ol' blog pipeline, but the good news now is that we actually have been
% able to sit down and write some of them.
%
% Over the next little while Ajay Puvvala will be publishing a series of
% posts related to some exciting features we have in MATLAB around test
% selection. Super exciting stuff so be sure to keep an eye out for these.
%
% While you wait, I also wanted to quickly plug a couple of GitHub
% repositories that we've published to help with your CI workflows. 
%
%% The simplest config that works
% First, if you want to just get up and going on your CI platform with the
% simplest of configs, take a look at the
% <https://github.com/mathworks/ci-configuration-examples CI Configuration
% Examples> repository. This shows a basic "Hello World!" example for
% GitHub(R) Actions, GitLab(R) CI/CD, Jenkins(TM), Azure(R) DevOps, and
% CircleCI(R). You can go there right now, fork it, and immediately use
% cloud hosted runners on GitHub, Azure DevOps, or CircleCI to see the CI
% process in action. Note, GitHub makes it particularly easy because
% Actions are just built into GitHub itself.
%
% <<2025-ci-config-examples.png>>
%
%
%% (Slightly) more advanced configurations
% Additionally, for those looking for more advanced configurations, check out the
% <https://github.com/mathworks/advanced-ci-configuration-examples Advanced CI Configuration
% Examples> repository. This includes more complex setups and best practices
% for integrating MATLAB with these CI/CD tools. In this repository you
% will currently find two workflows that are demonstrated on 4 CI
% platforms: GitHub Actions, Azure DevOps, Jenkins, and CircleCI.
%
% <<2025-advanced-config.png>>
%
%% Multi-platform Toolbox Creation
% The first example goes through the build of a MATLAB toolbox across 3
% platforms to produce and release a single *|*.mltbx|* file. This workflow
% currently shows:
% 
% * How to use a matrix build across platforms (Linux, Windows, and Mac)
% * Building platform specific mex files
% * Uploading these artifacts on each 
% * Retrieving the built mex files for each platform and packaging the
% toolbox
% * Publishing the toolbox to a GitHub release for distribution
% 
%% Multi-release deployment to integrate with Python(R)
% The second example shows how you can leverage the MATLAB Compiler SDK(TM)
% to create a python package from this algorithm. It does this across
% releases and operating systems. Some highlights of this workflow:
%
% * A double matric build (across MATLAB releases and operating systems
% % Creation and deployment of a python package from the MATLAB code using
% Compiler SDK
% * Equivalence testing of the deployed algorithm using
% <https://www.mathworks.com/products/matlab-test.html MATLAB Test>
% * Using
% <https://github.com/mathworks-ref-arch/matlab-dockerfile/blob/main/alternates/non-interactive/MATLAB-BATCH.md
% batch tokens> for licensing of MATLAB Compiler SDK on cloud hosted
% runners. While licensing of many MathWorks products is provided for public
% projects, batch tokens allow you to leverage other products not supported
% (like Coders and Compilers). They also enable you to leverage CI for
% private projects.
%
% It's great to be back! Stay tuned for more and we'd love to hear how you
% are doing and what you'd like to learn more about!