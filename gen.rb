require 'terminal-table'
require 'json'
require 'date'

json = `aws ec2 describe-instances --query 'Reservations[].Instances[].{box:join(\`,\`,Tags[?Key==\`Name\`].Value),state:State.Name,dev:join(\`,\`,Tags[?Key==\`Requestor\`].Value),time_started:LaunchTime}' --filters 'Name=tag:Purpose,Values=pairing' --region us-west-1 --output json`
instances = JSON.parse(json)
running = instances.select { |i| i["state"] == "running" }
not_running = instances - running

def sort_by(list, attribute)
  list.sort { |x,y| x[attribute] <=> y[attribute] }
end

def format_time(time_started)
  dt = DateTime.parse(time_started)
  dt.strftime("%m/%d %H:%M")
end

def create_rows(list)
  list.each_with_index.map { |i, idx| [ "%02s" % [idx + 1], i["box"], i["dev"], i["state"], format_time(i["time_started"]) ] }
end

headings = [ '', 'box', 'dev', 'state', 'started' ]
rows = []
rows.concat create_rows(sort_by(not_running, "dev"))
rows << :separator
rows.concat create_rows(sort_by(running, "dev"))
# rows << [ 'clever-salamander-1437','Bob Smith', 'running', '2015-03-24T13:17:34.000Z' ]
# rows << [ 'furious-donkey-8721','Joe Bloggs', 'running', '2015-03-24T13:17:34.000Z' ]
# rows << :separator
# rows << [ 'frigid-dingo-9002','Sandy Stevens', 'stopped', '2015-03-24T13:17:34.000Z' ]

table = Terminal::Table.new headings: headings, rows: rows
puts table
