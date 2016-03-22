require 'test_helper'

require 'ostruct'

class JrqTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jrq::VERSION
  end

  def setup
    @jrq = Jrq::Cli.new
    def @jrq.stdin
      open(File.dirname(__FILE__) + '/cluster.json').read
    end
  end

  def opts
    o = OpenStruct.new
    o.raw = true
    o
  end

  def test_run
    output = <<-EOL
{
  "Status": {
    "Timeline": {
      "ReadyDateTime": 1458381298.552,
      "CreationDateTime": 1458381023.864,
      "EndDateTime": 1458406899.37
    },
    "State": "TERMINATED",
    "StateChangeReason": {
      "Message": "Terminated by user request",
      "Code": "USER_REQUEST"
    }
  },
  "Hours": 192,
  "Id": "j-XXXXXXXXXXXXX",
  "Name": "TestCluster"
}
    EOL
    assert_output(output) { @jrq.run([], opts) }
  end

  def test_run_keys
    output = <<-EOL
Status
Hours
Id
Name
    EOL
    assert_output(output) { @jrq.run(['_.keys'], opts) }
  end

  # $ curl -s http://petstore-demo-endpoint.execute-api.com/petstore/pets | jrq '_.map(&:price)'
  def test_input
    @input = <<-EOL
[
  {
    "id": 1,
    "type": "dog",
    "price": 249.99
  },
  {
    "id": 2,
    "type": "cat",
    "price": 124.99
  },
  {
    "id": 3,
    "type": "fish",
    "price": 0.99
  }
]
    EOL
    def @jrq.stdin; @input end
    assert_output(@input)   { @jrq.run(['_'], opts) }
    assert_output('Array') { @jrq.run(['_.class'], opts) }
    # assert_output("#{249.99 + 124.99 + 0.99}") { @jrq.run(['_.map(&:price).reduce(&:+)'], opts) }
  end


end
