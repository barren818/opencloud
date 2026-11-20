# openEuler 单机云计算综合实验

在一台 VMware 虚拟机里的 openEuler 上，以企业 Linux 运维工程师的视角完成的单机综合实验：从用户与权限、LVM 存储、网络配置、Nginx 网站部署，到综合故障排查、Shell 自动巡检、备份恢复、安全加固、资源监控与 Podman 容器，共 12 个模块。

## 实验环境

- 宿主机：Windows 11 + VMware（NAT 网络）
- 虚拟机：openEuler 22.03 LTS SP4，2 核 / 实测内存 1.4 GiB / 40G 系统盘 + 20G 实验盘（LVM 卷组 company_vg）
- 远程访问：SSH 密钥登录（Ed25519，已关闭密码登录）

## 仓库结构

- `docs/` — 项目总报告、故障排查手册（7 个真实排障案例）、安全审查清单、资源监控报告、阶段回顾与复现清单
- `website/` — Nginx 网站首页两个版本：`index-host.html`（宿主机 Nginx，:80）、`index-container.html`（容器版，:8080）
- `scripts/` — Shell 巡检脚本：`disk_check.sh`（磁盘使用率巡检告警）、`nginx_check.sh`（Nginx 存活检查与自动拉起）
- `config/` — `nginx.conf`、`sshd_config`（加固后）、`fstab`、`root-crontab.txt`（巡检与备份的 cron 导出）、`99-ip-forward.conf`

## 实践亮点

- **权限与 SELinux**：多用户/用户组 + ACL 精细授权；改网站根目录后的 403 用 `semanage fcontext` + `restorecon` 正规修复，全程未关闭 SELinux
- **存储**：LVM 创建、在线扩容（故障演练中将 project_lv 由 6G 扩至 7G 并同步扩容文件系统）
- **故障排查**：服务停止、权限错误、DNS 失效、LV 空间不足、配置写坏致启动失败、fstab 未自动挂载、容器端口发布僵死，共 7 个案例，均按「现象 → 排查 → 原因 → 修复 → 验证」记录于故障排查手册
- **自动化运维**：Shell 巡检脚本 + cron 定时执行；tar 分项目归档 + rsync 增量镜像备份，并完成误删文件恢复演练全闭环；每日/每周自动备份已实际触发验证
- **安全加固**：SSH 仅密钥登录、防火墙放行收敛为必要服务、登录审计
- **容器**：Podman 运行 Nginx 容器，端口映射 8080:80 + 只读挂载网站目录，并完成容器生命周期（stop/start/rm 重建）验证

## 说明

本仓库为课程实验交付物，仅含文档、脚本、配置与网站文件；不含虚拟机镜像，也不含任何私钥、密码类凭证。`conf.d` 在交付时为空目录（实验中植入的故障配置文件已在排障后删除），故未收录。
