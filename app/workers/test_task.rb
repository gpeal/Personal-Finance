class TestTask
  include Resque::Base

  def perform(args)
    log("Running task with args " + args['b'])
  end
end