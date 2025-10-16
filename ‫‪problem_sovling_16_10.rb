def prime?(n)
  return false if n < 2
  
  (2..Math.sqrt(n)).none? {|i| n % i == 0}
  
  # !(2..Math.sqrt(n)).any? {|i| n % i == 0}
end
