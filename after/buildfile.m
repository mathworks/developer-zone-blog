function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("test") = TestTask("tests", SourceFiles="toolbox", RunOnlyImpactedTests=1);

% OR
% plan("test") = TestTask("tests", SourceFiles="toolbox");
% plan("test").RunOnlyImpactedTests = 1;

plan.DefaultTasks = "test";
end
