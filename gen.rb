require 'terminal-table'

headings = [ 'box', 'dev', 'state', 'created' ]
rows = []
rows << [ 'clever-salamander-1437','Bob Smith', 'running', '2015-03-24T13:17:34.000Z' ]
rows << [ 'furious-donkey-8721','Joe Bloggs', 'running', '2015-03-24T13:17:34.000Z' ]
rows << :separator
rows << [ 'frigid-dingo-9002','Sandy Stevens', 'stopped', '2015-03-24T13:17:34.000Z' ]

table = Terminal::Table.new headings: headings, rows: rows
puts table
