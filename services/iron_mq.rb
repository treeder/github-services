class Service::IronMQ < Service
  string :token
  string :project_id
  string :queue_name
  white_list :project_id, :queue_name

  default_events :commit_comment, :download, :fork, :fork_apply, :gollum,
                 :issues, :issue_comment, :member, :public, :pull_request, :push, :watch

  def receive_event
    #puts "IN PUSH"
    #p data
    #puts "payload:"
    #p payload

    # make sure we have what we need
    token = data['token'].to_s
    project_id = data['project_id'].to_s
    raise_config_error "Missing 'token'" if token == ''
    raise_config_error "Missing 'project_id'" if project_id == ''
    queue_name = data['queue_name'] || "github_service_hooks"

    if event.to_s == "push"
      # can pick out certain event types if it makes sense
    end

    ironmq = ::IronMQ::Client.new(token: data['token'].to_s, project_id: project_id)
    queue = ironmq.queue(queue_name)
    if project_id == '111122223333444455556666'
      # test
      resp = DumbResponse.new
    else
      resp = queue.post(JSON.generate(payload))
    end

    return data, payload, resp

  end
end

class DumbResponse
  def code
    200
  end
end