<template>
  <el-container class="layout-container">
    <el-header class="header">
      <div class="logo">
        <span class="logo-mark">
          <el-icon><StarFilled /></el-icon>
        </span>
        <span>志愿活动平台</span>
      </div>
      <el-menu mode="horizontal" :default-active="activeMenu" router class="header-menu">
        <el-menu-item index="/volunteer/activities">活动大厅</el-menu-item>
        <el-menu-item index="/volunteer/my-activities">我的活动</el-menu-item>
        <el-menu-item index="/volunteer/my-points">我的积分</el-menu-item>
        <el-menu-item index="/volunteer/rewards">积分商城</el-menu-item>
        <el-menu-item index="/volunteer/my-exchanges">我的兑换</el-menu-item>
        <el-menu-item index="/volunteer/ranking">排行榜</el-menu-item>
      </el-menu>
      <el-dropdown @command="handleCommand">
        <span class="user-info">
          <el-avatar :size="32" icon="User" />
          <span class="user-name">{{ userStore.userInfo.name }}</span>
          <el-icon><ArrowDown /></el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="profile">个人中心</el-dropdown-item>
            <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </el-header>
    <el-main class="main-content">
      <router-view />
    </el-main>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

const handleCommand = (command) => {
  if (command === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      userStore.logout()
      router.push('/login')
    })
  } else if (command === 'profile') {
    router.push('/volunteer/profile')
  }
}
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
}

.header {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  height: 68px;
  background: rgba(255, 255, 255, 0.92);
  border-bottom: 1px solid rgba(93, 205, 214, 0.24);
  box-shadow: 0 10px 26px rgba(74, 174, 184, 0.12);
  backdrop-filter: blur(16px);
  padding: 0 28px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 21px;
  font-weight: 800;
  color: #16858f;
  margin-right: 30px;
  white-space: nowrap;
}

.logo-mark {
  display: grid;
  place-items: center;
  width: 36px;
  height: 36px;
  border-radius: 8px;
  color: #fff;
  background: linear-gradient(135deg, #ffcf5b 0%, #20c6d6 100%);
  box-shadow: 0 8px 18px rgba(21, 184, 200, 0.22);
}

.header-menu {
  flex: 1;
  border: none;
  min-width: 0;
  overflow-x: auto;
  overflow-y: hidden;
  background: transparent;
}

.header-menu :deep(.el-menu-item) {
  height: 42px;
  border-radius: 8px;
  color: #56707a;
  font-weight: 650;
  margin: 0 2px;
}

.header-menu :deep(.el-menu-item.is-active) {
  color: #0f8d9a;
  background: #e5fafb;
  border-bottom-color: transparent;
}

.header-menu :deep(.el-menu-item:hover) {
  color: #0f8d9a;
  background: #f1fbfc;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 7px;
  cursor: pointer;
  margin-left: 20px;
  padding: 8px 10px;
  border: 1px solid #dff3f5;
  border-radius: 8px;
  color: #385263;
  background: #fff;
}

.user-name {
  max-width: 96px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.main-content {
  min-height: calc(100vh - 68px);
  background:
    linear-gradient(160deg, rgba(255, 244, 197, 0.46) 0%, rgba(235, 252, 255, 0.7) 50%, rgba(244, 255, 235, 0.62) 100%);
  padding: 28px;
}

@media (max-width: 900px) {
  .header {
    padding: 0 14px;
  }

  .logo span:last-child {
    display: none;
  }

  .user-name {
    display: none;
  }

  .main-content {
    padding: 18px;
  }
}
</style>
