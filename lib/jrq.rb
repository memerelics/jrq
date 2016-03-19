require "jrq/version"

require 'json'
require 'hashie'
require 'awesome_print'

module Jrq

  def self.run(args, opts)
    _ = JSON.load(STDIN.read)
    _ = Hashie::Mash.new(_)

    if ARGV.length.zero?
      display(_, opts)
    else
      display(eval(args.first), opts)
    end

  end

  def self.display(o, options)
    if o.is_a? Hash
      puts JSON.pretty_generate(o)
    else
      if options.raw
        puts o
      else
        ap o
      end
    end
  end

end
