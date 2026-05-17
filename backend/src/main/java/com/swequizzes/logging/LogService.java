package com.swequizzes.logging;

import com.swequizzes.account.Account;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class LogService {
    private static final int LOG_PAGE_SIZE = 10;

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

    public LogPage<AccessLog> recentAccessLogs(int page) {
        Page<AccessLog> result = accessLogRepository.findAll(pageRequest(page));
        return toLogPage(result);
    }

    public LogPage<SessionLog> recentSessionLogs(int page) {
        Page<SessionLog> result = sessionLogRepository.findAll(pageRequest(page));
        return toLogPage(result);
    }

    private PageRequest pageRequest(int page) {
        int safePage = Math.max(page, 0);
        return PageRequest.of(safePage, LOG_PAGE_SIZE, Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    private <T> LogPage<T> toLogPage(Page<T> page) {
        return new LogPage<>(page.getContent(), page.getNumber(), page.getSize(), page.getTotalPages(), page.getTotalElements());
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return value.trim();
    }
}
