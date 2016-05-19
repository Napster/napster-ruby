# Monkey patching String to add camel_case_lower conversion
module StringHelper
  refine String do
    def camel_case_lower
      split('_').inject([]) do |buffer, e|
        buffer.push(buffer.empty? ? e : e.capitalize)
      end.join
    end
  end
end
