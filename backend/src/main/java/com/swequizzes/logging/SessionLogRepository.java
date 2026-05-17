package com.swequizzes.logging;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SessionLogRepository extends JpaRepository<SessionLog, Long> {
}
