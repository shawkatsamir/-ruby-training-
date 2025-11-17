# SOLID VIOLATIONS 
# --------------------------------------------------------------------------

# 1. SRP (Single Responsibility Principle) — VIOLATED
#     Where: InvoiceProcessor#process does 5 things:
#        - Calculates subtotal
#        - Applies tax
#        - Handles payment logic
#        - Logs to file
#        - Sends email
#     Why: One class/method should have only ONE reason to change.
#           

# 2. OCP (Open/Closed Principle) — VIOLATED
#     Where: Big `if/elsif` chain on @payment_method
#     Why: Adding a new payment requires MODIFYING
#           

# 3. LSP (Liskov Substitution Principle) — NOT APPLICABLE (no inheritance),
#    but would be violated if subclasses were added due to tight coupling.

# 4. ISP (Interface Segregation Principle) — VIOLATED
#     Where: No interfaces; everything crammed into one method
#     Why: Clients (if any) would depend on behaviors they don’t use.

# 5. DIP (Dependency Inversion Principle) — VIOLATED
#     Where: Direct use of `File.open`, `puts`, and hardcoded email logic
#     Why: High-level InvoiceProcessor depends on LOW-LEVEL concretions
#           (file system, console), not abstractions.



class User
  attr_reader :name, :email, :country

  def initialize(name:, email:, country:)
    @name = name
    @email = email
    @country = country
  end
end


class TaxCalculator
  EG_TAX_RATE = 0.14
  DEFAULT_TAX_RATE = 0.20

  def self.calculate(total, country)
    rate = country == "EG" ? EG_TAX_RATE : DEFAULT_TAX_RATE
    total * (1 + rate)
  end
end


module PaymentProcessor
  def process_payment(total)
    raise NotImplementedError, 'Subclasses must implement process_payment'
  end
end



class VisaPayment 
  include PaymentProcessor

  def process_payment(total)
    "Paid using VISA"
  end
end

class PayPalPayment 
  include PaymentProcessor

  def process_payment(total)
    "Paid using PayPal"
  end
end

class CashPayment 
  include PaymentProcessor

  def process_payment(total)
    "Paid with CASH"
  end
end

def build_payment_processor(method)
  case method
  when :visa
    VisaPayment.new
  when :paypal
    PayPalPayment.new
  when :cash
    CashPayment.new
  else
    raise ArgumentError, "Payment method not supported: #{method.inspect}"
  end
end

class InvoiceLogger
  def initialize(filename = "invoice_log.txt")
    @filename = filename
  end

  def log(message)
    File.open(@filename, "a") do |file|
      file.puts message
    end
  end
end

class EmailService
  def send_payment_confirmation(user, total)
    "Email sent to #{user.email}: thanks for your purchase of $#{'%.2f' % total}"
  end
end


class InvoiceProcessor
  def initialize(user, items, payment_processor, logger, email_service:)
    @user = user
    @items = items
    @payment_processor = payment_processor
    @logger = logger
    @email_service = email_service
  end

  def process
    subtotal = calculate_subtotal
    total_with_tax = TaxCalculator.calculate(subtotal, @user.country)

    @payment_processor.process_payment(total_with_tax)

    @logger.log("User: #{@user.name}, Total: #{'%.2f' % total_with_tax}")

    @email_service.send_invoice_confirmation(@user, total_with_tax)

    total_with_tax
  end

  private

  def calculate_subtotal
    @items.sum { |item| item[:price] * item[:quantity] }
  end
end