<template>
  <router-view />
</template>

<script setup>
</script>

<style>
:root {
  --app-primary: #15b8c8;
  --app-primary-soft: #dff9fb;
  --app-coral: #ff7a7a;
  --app-yellow: #ffd166;
  --app-green: #55c985;
  --app-text: #27384a;
  --app-muted: #6c7a89;
  --app-line: #d9eef0;
  --app-surface: rgba(255, 255, 255, 0.9);
  --app-shadow: 0 14px 34px rgba(53, 158, 169, 0.14);

  --el-color-primary: #15b8c8;
  --el-color-primary-light-3: #65d3dc;
  --el-color-primary-light-5: #a4e7ec;
  --el-color-primary-light-7: #cff4f7;
  --el-color-primary-light-8: #e0f8fa;
  --el-color-primary-light-9: #f0fcfd;
  --el-color-primary-dark-2: #0fa0ae;
  --el-color-success: #55c985;
  --el-color-warning: #ffb84d;
  --el-color-danger: #ff6b6b;
  --el-color-info: #75a7d8;
  --el-text-color-primary: var(--app-text);
  --el-text-color-regular: #425466;
  --el-text-color-secondary: var(--app-muted);
  --el-border-color: var(--app-line);
  --el-border-color-light: #e8f5f6;
  --el-border-radius-base: 8px;
  --el-fill-color-light: #f5fbfc;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  background: #f5fcfd;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  color: var(--app-text);
  background:
    linear-gradient(140deg, rgba(255, 246, 208, 0.78) 0%, rgba(232, 252, 255, 0.92) 45%, rgba(250, 255, 238, 0.86) 100%);
  min-width: 320px;
}

#app {
  min-height: 100vh;
}

a {
  color: var(--app-primary);
}

.el-card {
  border: 1px solid rgba(105, 203, 211, 0.26);
  border-radius: 8px;
  background: var(--app-surface);
  box-shadow: var(--app-shadow);
}

.el-card__header {
  border-bottom: 1px solid #e5f4f5;
  padding: 18px 22px;
}

.el-card__body {
  padding: 22px;
}

.el-button {
  border-radius: 8px;
  font-weight: 600;
}

.el-button--primary {
  background: linear-gradient(135deg, #18c6d6 0%, #35c98d 100%);
  border-color: transparent;
  box-shadow: 0 8px 18px rgba(21, 184, 200, 0.18);
}

.el-button--primary:hover,
.el-button--primary:focus {
  border-color: transparent;
  filter: brightness(1.03);
}

.el-input__wrapper,
.el-textarea__inner,
.el-select__wrapper {
  border-radius: 8px;
  box-shadow: 0 0 0 1px #d9eef0 inset;
  background: rgba(255, 255, 255, 0.95);
}

.el-input__wrapper.is-focus,
.el-textarea__inner:focus,
.el-select__wrapper.is-focused {
  box-shadow: 0 0 0 1px var(--app-primary) inset, 0 0 0 3px rgba(21, 184, 200, 0.12);
}

.el-table {
  border-radius: 8px;
  overflow: hidden;
}

.el-table th.el-table__cell {
  background: #effbfc;
  color: #2f6f77;
  font-weight: 700;
}

.el-table td.el-table__cell,
.el-table th.el-table__cell.is-leaf {
  border-bottom-color: #e8f5f6;
}

.el-table--border .el-table__cell {
  border-right-color: #e8f5f6;
}

.el-tag {
  border-radius: 8px;
  font-weight: 600;
}

.el-dialog {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 22px 58px rgba(53, 158, 169, 0.2);
}

.el-dialog__header {
  padding: 20px 24px 12px;
}

.el-dialog__title,
.el-page-header__content,
h1,
h2,
h3 {
  color: var(--app-text);
  letter-spacing: 0;
}

.el-pagination.is-background .el-pager li.is-active {
  background: var(--app-primary);
}
</style>
