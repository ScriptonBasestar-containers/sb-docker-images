


백업 복원 테스트
restic restore latest --target /path/to/restore

보관 정책
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune
