namespace :merchant do
  desc 'Update block_transactions attribute based on percentage of chargebacked transactions when tehre is a relevant number of transactions'
  task update_merchants_blocked_transactions: :environment do
    Merchant.all.each do |merchant|
      total_transactions = merchant.transactions.count
      cbk_transactions = merchant.number_chargebacks
      next unless total_transactions > 10

      percentage_cbk = (cbk_transactions.to_f / total_transactions) * 100

      merchant.update(block_transactions: (percentage_cbk.to_f > 30))
    end
  end
end
