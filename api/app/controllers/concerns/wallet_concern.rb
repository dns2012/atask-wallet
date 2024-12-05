module WalletConcern
  extend ActiveSupport::Concern

  def set_user_wallet
    @user_wallet = @current_user.user_wallet
  end

  def set_target_wallet
    @target_wallet = UserWallet.find(params[:user_wallet_id])
  end

  def validate_balance_amount
    raise BadRequestException.new("insufficient amount, the wallet balance is not enough for the transaction!") unless @user_wallet.is_sufficient?(params[:amount])
  end

  def validate_target_wallet
    raise BadRequestException.new("invalid target user wallet id!") unless @user_wallet.is_transferable?(@target_wallet.id)
  end

  def exec_transfer
    ActiveRecord::Base.transaction do
      user_transaction = @user_wallet.transfer(params[:amount], @target_wallet.id)
      @target_wallet.receive(user_transaction.transaction_amount, user_transaction.id)
    end
  end
end
