# Change states using reg exps
# for each state do something
# DFA with outputs


input_file = ARGV[0]
states=[/^\# / => :topic_name, /^\* / => :question, /^\s*$/ => :ignore]
machine = StateMachine.new(states, input_file)

def set_topic_name (*args)
  machine_var_set :topic_name, args[0]
end

machine.work_for_state(:topic_name) { |*args| StateMachine.set_var(:topic_name, args[0]) }
machine.work_for_state(:question) do |*args| 
  topic=StateMachine.get_Var :topic_name
  puts "Topic: #{topic}\tQuestion: #{args[0]}"
end

machine.cycle
