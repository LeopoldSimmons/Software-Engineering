<template>
  <div class="dashboard-page">
    <div class="page-head">
      <div>
        <h2>数据概览</h2>
        <p>快速查看平台运行状态</p>
      </div>
    </div>

    <el-row :gutter="20">
      <el-col :xs="24" :md="8">
        <el-card class="stat-card users">
          <el-statistic title="总用户数" :value="stats.totalUsers">
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card class="stat-card activities">
          <el-statistic title="总活动数" :value="stats.totalActivities">
            <template #prefix>
              <el-icon><Trophy /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card class="stat-card hours">
          <el-statistic title="总志愿时长(小时)" :value="stats.totalVolunteerHours" :precision="1">
            <template #prefix>
              <el-icon><Timer /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
    </el-row>

    <el-card style="margin-top: 20px">
      <template #header>
        <h3>活动参与排行</h3>
      </template>
      <el-table :data="activityRanking" border>
        <el-table-column prop="title" label="活动名称" />
        <el-table-column prop="participants" label="参与人数" width="150">
          <template #default="{ row }">
            <el-progress :percentage="(row.participants / maxParticipants * 100)" />
            <span style="margin-left: 10px">{{ row.participants }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getOverview, getActivityRanking } from '@/api/stats'

const stats = ref({
  totalUsers: 0,
  totalActivities: 0,
  totalVolunteerHours: 0
})

const activityRanking = ref([])

const maxParticipants = computed(() => {
  if (activityRanking.value.length === 0) return 1
  return Math.max(...activityRanking.value.map(a => a.participants))
})

const loadStats = async () => {
  const res = await getOverview()
  stats.value = res.data
}

const loadActivityRanking = async () => {
  const res = await getActivityRanking()
  activityRanking.value = res.data
}

onMounted(() => {
  loadStats()
  loadActivityRanking()
})
</script>

<style scoped>
.dashboard-page {
  max-width: 1240px;
  margin: 0 auto;
}

.page-head {
  margin-bottom: 18px;
}

.page-head h2 {
  margin: 0 0 6px;
  font-size: 28px;
}

.page-head p {
  margin: 0;
  color: #6c7a89;
}

.stat-card {
  margin-bottom: 20px;
  overflow: hidden;
}

.stat-card :deep(.el-card__body) {
  position: relative;
  min-height: 130px;
  padding: 26px;
}

.stat-card :deep(.el-statistic__head) {
  color: #637a88;
  font-weight: 650;
}

.stat-card :deep(.el-statistic__content) {
  color: #263f4c;
}

.stat-card :deep(.el-statistic__prefix) {
  color: #0fa0ae;
}

.stat-card.users {
  background: linear-gradient(135deg, #fff 0%, #e8fbfd 100%);
}

.stat-card.activities {
  background: linear-gradient(135deg, #fff 0%, #fff3cb 100%);
}

.stat-card.hours {
  background: linear-gradient(135deg, #fff 0%, #eaffef 100%);
}

h3 {
  margin: 0;
}
</style>
