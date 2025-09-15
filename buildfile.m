function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("test") = TestTask(SourceFiles="toolbox", TestResults="results/test-results.xml");

plan.DefaultTasks = "test";
end
