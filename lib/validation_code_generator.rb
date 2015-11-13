module ValidationCodeGenerator
  module_function

    def gen_code(length = 6)
      codes = '0123456789'
      length.times.inject('') { |s| s << codes[rand(codes.length)]}
    end
end