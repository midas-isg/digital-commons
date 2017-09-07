package edu.pitt.isg.dc.entry.util;

import org.junit.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class TreeAidTest {
    @Test
    public void toParentPath() throws Exception {
        final String parentPath = TreeAid.toParentPath("1/2/3");
        assertThat(parentPath).isEqualTo("1/2");
    }
}
