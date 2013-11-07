#ifndef __ACTIONLIST_HPP__
#define __ACTIONLIST_HPP__

#include <stdlib.h>


typedef int     ActionListID;


class   ActionListNode
{
    friend  class   ActionList;

private:

    ActionListNode* Next;
    ActionListNode* Prev;
    void            ( *Action )( void );
    ActionListID    ID;

public:

};


class   ActionList
{

private:

    int               ActionMax;
    ActionListNode*   _ActionList;
    ActionListNode*   EntryBottom;
    ActionListNode*   FreeTop;
    ActionListNode*   Current;

    void    InitNode( ActionListNode* node );

public:

    ActionList( int action_max );
    ~ActionList();

    void Execute( void );
    ActionListID Entry( void ( *action )( void ) );
    void Delete( ActionListID );

};

#endif /* __ACTIONLIST_HPP__ */
