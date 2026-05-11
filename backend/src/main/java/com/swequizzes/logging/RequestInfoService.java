package com.swequizzes.logging;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Service;

@Service
public class RequestInfoService {

    public RequestInfo from(HttpServletRequest request) {
        String ip = firstHeader(request, "X-Forwarded-For");
        if (ip != null && ip.contains(",")) {
            ip = ip.substring(0, ip.indexOf(",")).trim();
        }
        if (ip == null) {
            ip = firstHeader(request, "X-Real-IP");
        }
        if (ip == null) {
            ip = request.getRemoteAddr();
        }

        String country = firstHeader(request, "CF-IPCountry");
        if (country == null) {
            country = firstHeader(request, "X-Vercel-IP-Country");
        }
        if (country == null) {
            country = firstHeader(request, "CloudFront-Viewer-Country");
        }
        if (country == null) {
            country = "UNKNOWN";
        }

        String userAgent = request.getHeader("User-Agent");
        return new RequestInfo(ip, country, userAgent);
    }

    private String firstHeader(HttpServletRequest request, String name) {
        String value = request.getHeader(name);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
