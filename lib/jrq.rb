require "jrq/version"

require 'json'
require 'hashie'
require 'awesome_print'

module Jrq

  class Cli

    def run(args, opts)
      _ = JSON.load(stdin)
      _ = Hashie::Mash.new(_)

      if args.length.zero?
        display(_, opts)
      else
        display(eval(args.first), opts)
      end
    end

    def stdin
      STDIN.read
    end

    def display(o, options)
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

end
