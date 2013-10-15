class TestTask
  @queue = :q
  def self.perform(id)
    puts "Running task with id: " + id
  end
end