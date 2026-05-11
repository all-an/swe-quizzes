package com.swequizzes.logging;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/access-log")
public class AccessLogController {
    private final LogService logService;
    private final RequestInfoService requestInfoService;

    public AccessLogController(LogService logService, RequestInfoService requestInfoService) {
        this.logService = logService;
        this.requestInfoService = requestInfoService;
    }

    @PostMapping
    public ResponseEntity<Void> create(@RequestBody(required = false) AccessLogRequest request, HttpServletRequest servletRequest) {
        String sessionKey = request == null ? null : request.sessionKey();
        logService.access(sessionKey, requestInfoService.from(servletRequest));
        return ResponseEntity.noContent().build();
    }
}
