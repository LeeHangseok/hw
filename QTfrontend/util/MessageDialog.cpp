/*
 * Hedgewars, a free turn based strategy game
 * Copyright (c) 2004-2012 Andrey Korotaev <unC0Rr@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#include "MessageDialog.h"

int MessageDialog::ShowErrorMessage(const QString & msg, QWidget * parent)
{
    return ShowMessage(msg, QMessageBox::tr("Hedgewars - Warning"), QMessageBox::Warning, parent);
}

int MessageDialog::ShowInfoMessage(const QString & msg, QWidget * parent)
{
    return ShowMessage(msg, QMessageBox::tr("Hedgewars - Information"), QMessageBox::Information, parent);
}

int MessageDialog::ShowMessage(const QString & msg, const QString & title, QMessageBox::Icon icon, QWidget * parent)
{
    QMessageBox msgMsg(parent);
    msgMsg.setIcon(icon);
    msgMsg.setWindowTitle(title.isEmpty() ? QMessageBox::tr("Hedgewars") : title);
    msgMsg.setText(msg);
    msgMsg.setWindowModality(Qt::WindowModal);
    return msgMsg.exec();
}
