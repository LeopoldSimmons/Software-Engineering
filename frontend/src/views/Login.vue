<template>
  <div class="login-container">
    <el-card class="login-card">
      <template #header>
        <div class="card-header">
          <div class="brand-badge">
            <el-icon><Sunrise /></el-icon>
          </div>
          <h2>志愿活动管理平台</h2>
          <p>登录</p>
        </div>
      </template>
      <el-form :model="form" :rules="rules" ref="formRef" label-width="0">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" prefix-icon="User" size="large" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="密码" prefix-icon="Lock" size="large" @keyup.enter="handleLogin" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" style="width: 100%" :loading="loading" @click="handleLogin">登录</el-button>
        </el-form-item>
        <div class="register-link">
          还没有账号？<router-link to="/register">立即注册</router-link>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/auth'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()
const loading = ref(false)

const form = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    const res = await login(form)
    userStore.setToken(res.data.token)
    userStore.setUserInfo(res.data.user)
    ElMessage.success('登录成功')
    
    if (res.data.user.role === 'ADMIN') {
      router.push('/admin/dashboard')
    } else {
      router.push('/volunteer/activities')
    }
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background:
    linear-gradient(135deg, rgba(255, 235, 158, 0.82) 0%, rgba(218, 250, 255, 0.96) 46%, rgba(226, 255, 232, 0.9) 100%);
}

.login-card {
  width: min(420px, 100%);
  border: 1px solid rgba(80, 200, 208, 0.28);
  box-shadow: 0 24px 60px rgba(54, 163, 174, 0.18);
}

.card-header {
  text-align: center;
}

.brand-badge {
  display: grid;
  place-items: center;
  width: 58px;
  height: 58px;
  margin: 0 auto 14px;
  border-radius: 8px;
  color: #fff;
  font-size: 28px;
  background: linear-gradient(135deg, #ffca4f 0%, #16c7d7 100%);
  box-shadow: 0 12px 24px rgba(21, 184, 200, 0.22);
}

.card-header h2 {
  margin: 0 0 10px 0;
  color: #244858;
  font-size: 25px;
}

.card-header p {
  margin: 0;
  color: #71909b;
  font-size: 14px;
}

.register-link {
  text-align: center;
  font-size: 14px;
  color: #617888;
}

.register-link a {
  color: #0fa0ae;
  font-weight: 700;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}
</style>
