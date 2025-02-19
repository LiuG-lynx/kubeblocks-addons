set -o pipefail
export PATH="$PATH:$DP_DATASAFED_BIN_PATH"
export DATASAFED_BACKEND_BASE_PATH="$DP_BACKUP_BASE_PATH"
trap handle_exit EXIT
cd ${DATA_DIR}
START_TIME=$(get_current_time)
# TODO: flush data and locked write, otherwise data maybe inconsistent
# NOTE: if files changed during taring, the exit code will be 1 when it ends.
tar -czvf - ./ | datasafed push -z zstd - "${DP_BACKUP_NAME}.tar.zst"
rm -rf mongodb.backup
# stat and save the backup information
stat_and_save_backup_info $START_TIME
