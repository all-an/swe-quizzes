package com.swequizzes.logging;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface SessionLogRepository extends JpaRepository<SessionLog, Long> {
    List<SessionLog> findTop100ByOrderByCreatedAtDesc();
}
