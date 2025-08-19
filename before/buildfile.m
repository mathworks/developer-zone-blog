function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("test") = TestTask("tests", SourceFiles="toolbox");

plan.DefaultTasks = "test";
end
