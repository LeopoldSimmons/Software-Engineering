<template>
  <div class="activities-page">
    <div class="page-head">
      <div>
        <h2>活动大厅</h2>
        <p>发现适合自己的志愿活动</p>
      </div>
      <el-tag type="success" effect="light">公益同行</el-tag>
    </div>

    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="活动状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 150px">
            <el-option label="报名中" :value="1" />
            <el-option label="进行中" :value="2" />
            <el-option label="已结束" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="活动标题">
          <el-input v-model="searchForm.title" placeholder="请输入活动标题" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadActivities">查询</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-row :gutter="20" class="activity-grid">
      <el-col :xs="24" :sm="12" :lg="8" v-for="activity in activities" :key="activity.id">
        <el-card class="activity-card" shadow="hover">
          <div class="activity-top">
            <div class="activity-icon">
              <el-icon><Flag /></el-icon>
            </div>
            <el-tag :type="getStatusType(activity.status)" size="small">
              {{ getStatusText(activity.status) }}
            </el-tag>
          </div>
          <h3>{{ activity.title }}</h3>
          <p class="description">{{ activity.description }}</p>
          <div class="info-item">
            <el-icon><Location /></el-icon>
            <span>{{ activity.location }}</span>
          </div>
          <div class="info-item">
            <el-icon><Clock /></el-icon>
            <span>{{ activity.startTime }}</span>
          </div>
          <div class="info-item">
            <el-icon><User /></el-icon>
            <span>{{ activity.currentParticipants }}/{{ activity.maxParticipants }}</span>
          </div>
          <div class="info-item">
            <el-icon><Coin /></el-icon>
            <span class="points-text">{{ activity.points }} 积分</span>
          </div>
          <div class="info-item">
            <el-icon><Timer /></el-icon>
            <span>{{ activity.hours }} 小时</span>
          </div>
          <div class="card-actions">
            <el-button type="primary" size="small" @click="viewDetail(activity.id)">查看详情</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-pagination
      v-if="total > 0"
      style="margin-top: 20px; text-align: center"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="pageSize"
      :current-page="currentPage"
      @current-change="handlePageChange"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getActivityList } from '@/api/activity'

const router = useRouter()

const activities = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(9)

const searchForm = reactive({
  status: null,
  title: ''
})

const getStatusType = (status) => {
  const types = { 0: 'info', 1: 'success', 2: 'warning', 3: '', 4: 'danger' }
  return types[status]
}

const getStatusText = (status) => {
  const texts = { 0: '草稿', 1: '报名中', 2: '进行中', 3: '已结束', 4: '已取消' }
  return texts[status]
}

const loadActivities = async () => {
  const res = await getActivityList({
    page: currentPage.value,
    size: pageSize.value,
    ...searchForm
  })
  activities.value = res.data.records
  total.value = res.data.total
}

const handlePageChange = (page) => {
  currentPage.value = page
  loadActivities()
}

const viewDetail = (id) => {
  router.push(`/volunteer/activities/${id}`)
}

onMounted(() => {
  loadActivities()
})
</script>

<style scoped>
.activities-page {
  max-width: 1240px;
  margin: 0 auto;
}

.page-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
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

.search-card {
  background: rgba(255, 255, 255, 0.82);
}

.activity-grid {
  margin-top: 20px;
}

.activity-card {
  margin-bottom: 20px;
  min-height: 315px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.activity-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 18px 40px rgba(53, 158, 169, 0.18);
}

.activity-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.activity-icon {
  display: grid;
  place-items: center;
  width: 42px;
  height: 42px;
  border-radius: 8px;
  color: #0f8d9a;
  background: linear-gradient(135deg, #e6fbfd 0%, #fff3c7 100%);
}

.activity-card h3 {
  margin: 0 0 10px 0;
  color: #27384a;
  font-size: 18px;
}

.description {
  color: #667888;
  margin: 10px 0;
  min-height: 42px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 8px 0;
  color: #58707c;
  font-size: 14px;
}

.info-item .el-icon {
  color: #18aeba;
}

.points-text {
  color: #0fa0ae;
  font-weight: 800;
}

.card-actions {
  margin-top: 15px;
}

@media (max-width: 640px) {
  .page-head {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>
