<template>
  <div class="register-container">
    <el-card class="register-card">
      <template #header>
        <div class="card-header">
          <div class="brand-badge">
            <el-icon><Sunrise /></el-icon>
          </div>
          <h2>志愿活动管理平台</h2>
          <p>注册志愿者账号</p>
        </div>
      </template>
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" placeholder="请再次输入密码" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" style="width: 100%" :loading="loading" @click="handleRegister">注册</el-button>
        </el-form-item>
        <div class="login-link">
          已有账号？<router-link to="/login">立即登录</router-link>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { register } from '@/api/auth'

const router = useRouter()
const formRef = ref()
const loading = ref(false)

const form = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  name: '',
  phone: ''
})

const validatePassword = (rule, value, callback) => {
  if (value !== form.password) {
    callback(new Error('两次密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3-20之间', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validatePassword, trigger: 'blur' }
  ],
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    await register(form)
    ElMessage.success('注册成功，请登录')
    router.push('/login')
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background:
    linear-gradient(135deg, rgba(255, 235, 158, 0.82) 0%, rgba(218, 250, 255, 0.96) 46%, rgba(226, 255, 232, 0.9) 100%);
}

.register-card {
  width: min(470px, 100%);
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

.login-link {
  text-align: center;
  font-size: 14px;
  color: #617888;
}

.login-link a {
  color: #0fa0ae;
  font-weight: 700;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
