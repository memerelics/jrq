require "jrq/version"

require 'json'
require 'hashie'

module Jrq

  class Cli

    def run(args, opts)
      _ = JSON.load(stdin)
      _ = case _
          when Hash  then Hashie::Mash.new(_)
          when Array then _.map{|obj| Hashie::Mash.new(obj) }
          end
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
      if options.raw
        if o.is_a?(Hash)
          puts JSON.pretty_generate(o)
        elsif o.is_a?(Array) && o.any?{|ob| ob.is_a?(Hash) }
          puts JSON.pretty_generate(o)
        else
          puts o
        end
      else
        puts JSON.pretty_generate(o) rescue puts o
      end
    end

  end

end
