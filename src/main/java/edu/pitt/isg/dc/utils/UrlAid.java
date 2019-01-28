/*
 * Copyright (C) 2016 University of Pittsburgh.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */
package edu.pitt.isg.dc.utils;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;

@Component
@RequiredArgsConstructor
public class UrlAid {
    @Value("${app.https.enable:true}")
    private boolean isForcedToHttps = true;

    public String toUrlString(HttpServletRequest request, String... pathSegments) {
        return toContextUrlBuilder(request).pathSegment(pathSegments).build().normalize().toString();
    }

    private UriComponentsBuilder toContextUrlBuilder(HttpServletRequest request) {
        UriComponentsBuilder builder = UriComponentsBuilder.newInstance()
                .scheme(request.getScheme())
                .host(request.getServerName());

        int serverPort = request.getServerPort();
        if (serverPort != 80 && serverPort != 443) {
            builder = builder.port(serverPort);
        }

        String contextPath = request.getContextPath();
        if (contextPath != null && ! contextPath.isEmpty()) {
            builder = builder.path(contextPath);
        }

        if (isForcedToHttps)
            builder.scheme("https");

        return builder;
    }

    public String changeScheme(String url) {
        if (isForcedToHttps)
            return url.replace("http://", "https://");
        return url;
    }
}