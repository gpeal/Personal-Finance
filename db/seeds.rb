TaskType.delete_all
TaskType.create(id: 1, name: "Test Task", description: "A simple sanity check.", klass: "TestTask")
TaskType.create(id: 2, name: "Scrape Fidelity", description: "Scrape the recent buys on Fidelity", klass: "FidelityResearch")

TaskStatus.delete_all
TaskStatus.create(id: 1, status: "created")
TaskStatus.create(id: 2, status: "queued")
TaskStatus.create(id: 3, status: "in progress")
TaskStatus.create(id: 4, status: "succeeded")
TaskStatus.create(id: 5, status: "failed")