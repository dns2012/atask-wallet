<script setup lang="ts">
  definePageMeta({
    middleware: 'auth'
  })

  const auth = useAuthStore()
  const exception = useExceptionStore()
  const load = ref(false)
  const successMessage = ref('')
  const activePage = ref('dashboard')

  const user = ref({})
  const wallet = ref({})
  const walletHistoryList = ref([])
  const transactionList = ref([])
  const walletList = ref([])
  const amount = ref(0)
  const walletID = ref('')

  setup()

  async function setup() {
    fetchUser()
    fetchWallet()
    if (walletHistoryList.value.length < 1) {
      fetchWalletHistory()
    }
  }

  async function fetchUser() {
    const res = await getRequest('api/v1/auth/me', true)
    if (res) {
      user.value = res
    }
  }

  async function fetchWallet() {
    const res = await getRequest('api/v1/wallet', true)
    if (res) {
      wallet.value = res
    }
  }

  async function fetchWalletHistory() {
    const res = await getRequest('api/v1/wallet/history', true)
    if (res) {
      walletHistoryList.value = res
    }
  }

  async function fetchTransactionList() {
    const res = await getRequest('api/v1/transaction', true)
    if (res) {
      transactionList.value = res
    }
  }

  async function fetchWalletList() {
    const res = await getRequest('api/v1/wallet/list', true)
    if (res) {
      walletList.value = res
    }
  }

  async function setPage(page: string) {
    activePage.value = page
    switch (page) {
      case 'dashboard':
        setDashboard()
        break;
      case 'transaction':
        setTransaction()
        break;
      case 'deposit':
        setDeposit()
        break;
      case 'withdraw':
        setWithdraw()
        break;
      case 'transfer':
        setTransfer()
        break;
      default:
        setDashboard()
        break;
    }
  }

  async function setDashboard() {
    fetchWalletHistory()
  }

  async function setTransaction() {
    fetchTransactionList()
  }

  async function setDeposit() {
    // TODO: Deposit Page Action If Needed
  }

  async function submitDeposit() {
    const confirmed = confirm('Are you sure you want to deposit this balance?');
    load.value = true
    if (confirmed) {
      const res = await postRequest('api/v1/wallet/deposit', {amount: amount.value}, true)
      if (res) {
        wallet.value = res
        setSuccessMessage('Transaction success!')
      }
    }
    load.value = false
    setNeutralAmount()
  }

  async function setWithdraw() {
    // TODO: Withdraw Page Action If Needed
  }

  async function submitWithdraw() {
    const confirmed = confirm('Are you sure you want to withdraw this balance?');
    load.value = true
    if (confirmed) {
      const res = await postRequest('api/v1/wallet/withdraw', {amount: amount.value}, true)
      if (res) {
        wallet.value = res
        setSuccessMessage('Transaction success!')
      }
    }
    load.value = false
    setNeutralAmount()
  }

  async function setTransfer() {
    if (walletList.value.length < 1) {
      fetchWalletList()
    }
  }

  async function submitTransfer() {
    const confirmed = confirm('Are you sure you want to transfer this balance?');
    load.value = true
    if (confirmed) {
      const res = await postRequest('api/v1/wallet/transfer', {user_wallet_id: walletID.value, amount: amount.value}, true)
      if (res) {
        wallet.value = res
        setSuccessMessage('Transaction success!')
      }
    }
    load.value = false
    setNeutralAmount()
    setNeutralWalletID()
  }

  async function setNeutralAmount() {
    amount.value = 0
  }

  async function setNeutralWalletID() {
    walletID.value = ''
  }

  async function setSuccessMessage(message: string, duration = 5000) {
    successMessage.value = message;
    setTimeout(() => {
      successMessage.value = '';
    }, duration);
  }

  async function logout() {
    const confirmed = confirm('Are you sure you want to log out?');
    if (confirmed) {
      auth.setAuthToken('');
      navigateTo('auth');
    }
  }
</script>
<template>
  <div class="min-h-screen flex bg-gray-100">
    <!-- Sidebar -->
    <div class="w-64 bg-white p-6">
      <div class="mb-6 text-center">
        <img class="w-16 h-16 rounded-full mx-auto" src="https://randomuser.me/api/portraits/men/1.jpg" alt="Profile">
        <p class="mt-2 font-semibold text-lg">{{ user.name || 'Guest' }}</p>
        <p class="text-sm text-gray-500">Wallet Balance: <span class="text-blue-700">{{ wallet.balance || 0}}</span></p>
      </div>

      <!-- Menu -->
      <ul>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="setPage('dashboard')" class="block text-gray-700 px-4 py-2 hover:bg-gray-200 rounded" :class="{ '!text-blue-700 bg-gray-300 font-bold': activePage === 'dashboard' }">Dashboard</a>
        </li>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="setPage('transaction')" class="block text-gray-700 px-4 py-2 hover:bg-gray-200 rounded" :class="{ '!text-blue-700 bg-gray-300 font-bold': activePage === 'transaction' }">Transaction</a>
        </li>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="setPage('deposit')" class="block text-gray-700 px-4 py-2 hover:bg-gray-200 rounded" :class="{ '!text-blue-700 bg-gray-300 font-bold': activePage === 'deposit' }">Deposit</a>
        </li>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="setPage('withdraw')" class="block text-gray-700 px-4 py-2 hover:bg-gray-200 rounded" :class="{ '!text-blue-700 bg-gray-300 font-bold': activePage === 'withdraw' }">Withdraw</a>
        </li>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="setPage('transfer')" class="block text-gray-700 px-4 py-2 hover:bg-gray-200 rounded" :class="{ '!text-blue-700 bg-gray-300 font-bold': activePage === 'transfer' }">Transfer</a>
        </li>
        <li class="mb-4">
          <a href="javascript:void(0)" @click="logout" class="block text-red-700 px-4 py-2 hover:bg-gray-200 rounded">Log Out</a>
        </li>
      </ul>
    </div>

    <!-- Main Content -->
    <div class="flex-1 p-6">

      <h1 class="text-2xl font-semibold text-gray-800 mb-6 capitalize">{{  activePage  }}</h1>

      <div v-if="successMessage" class="flex items-center gap-2 px-4 py-2 bg-green-300 text-green-700 rounded-lg mb-6">
        <span>{{ successMessage }}</span>
      </div>

      <div v-if="exception.isError" class="flex items-center gap-2 px-4 py-2 bg-red-300 text-red-700 rounded-lg mb-6">
        <span>{{ exception.exception }}</span>
      </div>

      <!-- DASHBOARD BOX -->
      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="activePage == 'dashboard' && !load">
        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr class="border-b">
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600">Date</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-center">Balance Type</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-right">Amount</th>
            </tr>
          </thead>
          <tbody v-if="walletHistoryList.length > 0">
            <tr class="border-b" v-for="item in walletHistoryList" :key="item.id">
              <td class="px-4 py-2 text-sm text-gray-700">
                {{ new Intl.DateTimeFormat('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit',
                  timeZoneName: 'short',
                }).format(new Date(item.created_at)) }}
              </td>
              <td class="px-4 py-2 text-sm text-gray-700 capitalize text-center">
                <span class="ml-2 px-2 py-1 text-xs font-medium text-green-800 bg-green-100 rounded"  :class="{ '!text-red-800 !bg-red-100': item.balance_type === 'debit' }">{{ item.balance_type }}</span>
              </td>
              <td class="px-4 py-2 text-sm text-gray-700 text-right" :class="{ '!text-red-500': item.balance_type === 'debit' }">{{ item.balance_amount }}</td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-5 text-xl text-gray-700 font-bold border-r text-center" colspan="2">Total Balance</td>
              <td class="px-4 py-5 text-xl text-gray-700 font-bold text-right">{{  wallet.balance  }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- TRANSACTION BOX -->
      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="activePage == 'transaction' && !load">
        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr class="border-b">
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600">Date</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-center">Transaction Type</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-center">From</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-center">To</th>
              <th class="px-4 py-2 text-left text-sm font-semibold text-gray-600 text-right">Amount</th>
            </tr>
          </thead>
          <tbody v-if="transactionList.length > 0">
            <tr class="border-b" v-for="item in transactionList" :key="item.id">
              <td class="px-4 py-2 text-sm text-gray-700">
                {{ new Intl.DateTimeFormat('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit',
                  timeZoneName: 'short',
                }).format(new Date(item.created_at)) }}
              </td>
              <td class="px-4 py-2 text-sm text-gray-700 capitalize text-center">
                <span class="ml-2 px-2 py-1 text-xs font-medium text-green-800 bg-green-100 rounded"  :class="{ '!text-red-800 !bg-red-100': item.balance_type === 'debit' }">{{ item.transaction_type }}</span>
              </td>
              <td class="px-4 py-2 text-sm text-gray-700 capitalize text-center">{{ item.from_wallet_alias ?? '-' }}</td>
              <td class="px-4 py-2 text-sm text-gray-700 capitalize text-center">{{ item.to_wallet_alias ?? '-' }}</td>
              <td class="px-4 py-2 text-sm text-gray-700 text-right" :class="{ '!text-red-500': item.balance_type === 'debit' }">{{ item.balance_amount }}</td>
            </tr>
            <tr class="border-b">
              <td class="px-4 py-5 text-xl text-gray-700 font-bold border-r text-center" colspan="2">Total Balance</td>
              <td class="px-4 py-5 text-xl text-gray-700 font-bold text-right">{{  wallet.balance  }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- DEPOSIT BOX -->
      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="activePage == 'deposit' && !load">
        <form @submit.prevent="submitDeposit">
          <div class="mb-4">
            <label for="deposit" class="block text-base font-medium text-gray-600 mb-1">Deposit Balance</label>
            <input
              v-model="amount"
              min="10000"
              type="number"
              id="deposit"
              placeholder="Enter Amount of Balance"
              class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
              required
            />
          </div>
          <button
              type="submit"
              class="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 focus:ring-2 focus:ring-blue-400"
            >
            SUBMIT
          </button>
        </form>
      </div>

      <!-- WITHDRAW BOX -->
      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="activePage == 'withdraw' && !load">
        <form @submit.prevent="submitWithdraw">
          <div class="mb-4">
            <label for="deposit" class="block text-base font-medium text-gray-600 mb-1">Withdraw Balance</label>
            <input
              v-model="amount"
              min="10000"
              type="number"
              id="withdraw"
              placeholder="Enter Amount of Balance"
              class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
              required
            />
          </div>
          <button
              type="submit"
              class="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 focus:ring-2 focus:ring-blue-400"
            >
            SUBMIT
          </button>
        </form>
      </div>

      <!-- TRANSFER BOX -->
      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="activePage == 'transfer' && !load">
        <form @submit.prevent="submitTransfer">
          <div class="mb-4">
            <label for="wallet-list" class="block text-base font-medium text-gray-600 mb-1">Target Wallet</label>
            <select
              v-if="walletList.length > 0"
              v-model="walletID"
              id="wallet-list"
              class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
              required
            >
              <option value="">-- select wallet --</option>
              <option v-for="item in walletList" :key="item.id" :value="item.id">{{  item.wallet_alias  }}</option>
            </select>
          </div>
          <div class="mb-4">
            <label for="deposit" class="block text-base font-medium text-gray-600 mb-1">Amount of Balance</label>
            <input
              v-model="amount"
              min="10000"
              type="number"
              id="transfer"
              placeholder="Enter Amount of Balance"
              class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
              required
            />
          </div>
          <button
              type="submit"
              class="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 focus:ring-2 focus:ring-blue-400"
            >
            SUBMIT
          </button>
        </form>
      </div>

      <div class="bg-white p-6 mb-6 rounded-lg shadow-sm" v-if="load">
        <p class="text-gray-600">Loading...</p>
      </div>
    </div>
  </div>

</template>
