task "check failing builds" do |t|
  t.every "5s"
  t.action do |bot|
    json = open("http://127.0.0.1:1337").read
    ci = JSON.parse(json)
    old_failing_jons = bot.memory.fetch(:jenkins_failing_builds, [])
    failing_jobs = ci["jobs"].find_all { |job| job["color"] == "red" }
    bot.memory[:jenkins_failing_builds] = failing_jobs

    new_failing_jobs = failing_jobs - old_failing_jons

    if new_failing_jobs.any?
      if new_failing_jobs.count > 1
        failing_job_names = new_failing_jobs.map { |job| job["name"] }.join(", ")
        "#{new_failing_jobs.count} new failing builds: #{failing_job_names}"
      else
        "#{new_failing_jobs.first["name"]} started failing"
      end
    end
  end
end

command "dog" do
  matches "dog"

  subcommand "jekins" do
    matches "ci", "jenkins"
    action do
      json = open("http://127.0.0.1:1337").read
      ci = JSON.parse(json)
      failing_jobs = ci["jobs"].find_all { |job| job["color"] == "red" }

      if failing_jobs.any?
        failing_job_names = failing_jobs.map { |job| job["name"] }.join(", ")
        "#{failing_jobs.count} failing builds: #{failing_job_names}"
      else
        "no failing builds!"
      end
    end
  end
end
