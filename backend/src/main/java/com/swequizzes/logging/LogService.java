package com.swequizzes.logging;

import com.swequizzes.account.Account;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class LogService {
    private final AccessLogRepository accessLogRepository;
    private final SessionLogRepository sessionLogRepository;

    public LogService(AccessLogRepository accessLogRepository, SessionLogRepository sessionLogRepository) {
        this.accessLogRepository = accessLogRepository;
        this.sessionLogRepository = sessionLogRepository;
    }

    public AccessLog access(String sessionKey, RequestInfo info) {
        AccessLog log = new AccessLog();
        log.setSessionKey(blankToNull(sessionKey));
        log.setIpAddress(info.ipAddress());
        log.setCountry(info.country());
        log.setUserAgent(info.userAgent());
        return accessLogRepository.save(log);
    }

    public SessionLog session(Account account, String eventType, RequestInfo info) {
        SessionLog log = new SessionLog();
        log.setAccount(account);
        log.setEventType(eventType);
        log.setIpAddress(info.ipAddress());
        log.setCountry(info.country());
        log.setUserAgent(info.userAgent());
        return sessionLogRepository.save(log);
    }

    public List<AccessLog> recentAccessLogs() {
        return accessLogRepository.findTop100ByOrderByCreatedAtDesc();
    }

    public List<SessionLog> recentSessionLogs() {
        return sessionLogRepository.findTop100ByOrderByCreatedAtDesc();
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return value.trim();
    }
}
