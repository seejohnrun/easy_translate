module EasyTranslate

  class ParamBuilder

    def initialize
      @str = ''
    end

    def add(param, value)
      if @str.empty?
        @str << "#{param.to_s}=#{value}"
      else
        @str << "&#{param.to_s}=#{value}"
      end
    end

    def to_s
      @str
    end

  end

end
