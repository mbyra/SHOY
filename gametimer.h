#ifndef GAMETIMER_H
#define GAMETIMER_H

#include <QObject>
#include <QElapsedTimer>

/*
 * GameTimer class object measures elapsed time
 * in the game and is used e.g. to scroll the game
 * board.
 */

class GameTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int elapsed MEMBER m_elapsed NOTIFY elapsedChanged)
    Q_PROPERTY(bool running MEMBER m_running NOTIFY runningChanged)
private:
    QElapsedTimer m_timer;
    int m_elapsed;
    bool m_running;
public slots:
    // Starts timer
    void start() {
        this->m_running = true;
        m_timer.start();
        emit runningChanged();
    }

    // Restarts timer
    void restart(){
        this->m_elapsed = 0;
        m_timer.restart();
        this->m_running = true;
        emit runningChanged();
    }

    // Stops timer
    void stop() {
        this->m_elapsed = m_timer.elapsed();
        this->m_running = false;

        emit elapsedChanged();
        emit runningChanged();
    }

    // Acquires miliseconds count
    qint64 getTime(){
        return m_timer.elapsed();
    }

signals:
    // Signal when running has been changed
    void runningChanged();
    // Signal when elapsed time has been updated
    void elapsedChanged();
};

#endif // GAMETIMER_H
