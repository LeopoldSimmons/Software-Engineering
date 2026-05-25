<template>
  <div class="points-page">
    <div class="page-head">
      <div>
        <h2>我的积分</h2>
        <p>查看积分余额、获取记录与志愿时长</p>
      </div>
    </div>

    <el-row :gutter="20">
      <el-col :xs="24" :md="8">
        <el-card class="stat-card total">
          <el-statistic title="总积分" :value="stats.totalPoints">
            <template #prefix>
              <el-icon><Coin /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card class="stat-card available">
          <el-statistic title="可用积分" :value="stats.availablePoints">
            <template #prefix>
              <el-icon><Wallet /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card class="stat-card hours">
          <el-statistic title="志愿时长(小时)" :value="stats.volunteerHours" :precision="1">
            <template #prefix>
              <el-icon><Timer /></el-icon>
            </template>
          </el-statistic>
        </el-card>
      </el-col>
    </el-row>

    <el-card style="margin-top: 20px">
      <template #header>
        <h3>积分明细</h3>
      </template>
      <el-table :data="records" border>
        <el-table-column prop="type" label="类型" width="120">
          <template #default="{ row }">
            <el-tag :type="getTypeTag(row.type)">{{ getTypeText(row.type) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="points" label="积分变动" width="120">
          <template #default="{ row }">
            <span :style="{ color: row.points > 0 ? '#67c23a' : '#f56c6c', fontWeight: 'bold' }">
              {{ row.points > 0 ? '+' : '' }}{{ row.points }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="balance" label="余额" width="120" />
        <el-table-column prop="relatedTitle" label="关联" />
        <el-table-column prop="remark" label="备注" />
        <el-table-column prop="createTime" label="时间" width="180" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMyStats } from '@/api/stats'
import { getMyPointsRecords } from '@/api/points'

const stats = ref({
  totalPoints: 0,
  availablePoints: 0,
  volunteerHours: 0
})

const records = ref([])

const getTypeTag = (type) => {
  const tags = { 1: 'success', 2: 'danger', 3: 'warning' }
  return tags[type]
}

const getTypeText = (type) => {
  const texts = { 1: '活动获得', 2: '兑换扣除', 3: '管理员调整' }
  return texts[type]
}

const loadStats = async () => {
  const res = await getMyStats()
  stats.value = res.data
}

const loadRecords = async () => {
  const res = await getMyPointsRecords()
  records.value = res.data
}

onMounted(() => {
  loadStats()
  loadRecords()
})
</script>

<style scoped>
.points-page {
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
}

.stat-card :deep(.el-card__body) {
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

.stat-card.total {
  background: linear-gradient(135deg, #fff 0%, #fff3cb 100%);
}

.stat-card.available {
  background: linear-gradient(135deg, #fff 0%, #e8fbfd 100%);
}

.stat-card.hours {
  background: linear-gradient(135deg, #fff 0%, #eaffef 100%);
}

h3 {
  margin: 0;
}
</style>
