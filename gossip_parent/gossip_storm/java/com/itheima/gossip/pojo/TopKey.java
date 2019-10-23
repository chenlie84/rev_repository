package com.itheima.gossip.pojo;

/**
 * @CLassName TopKey
 * @Description TODO
 **/
public class TopKey {
    private String keyword;
    private double score;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    @Override
    public String toString() {
        return "TopKey{" +
                "keyword='" + keyword + '\'' +
                ", score=" + score +
                '}';
    }
}
