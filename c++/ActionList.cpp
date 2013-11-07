
#include "ActionList.hpp"


void    ActionList::InitNode(
    ActionListNode*   node )
{
    node->Next = NULL;
    node->Prev = NULL;
    node->Action = NULL;

    node->Next = FreeTop;
    FreeTop = node;
}


ActionList::ActionList(
    int     action_max )
{
    ActionMax = action_max;
    _ActionList = new ActionListNode [ ActionMax + 2 ];

    EntryBottom = &( _ActionList[ 0 ] );
    EntryBottom->Next = NULL;
    EntryBottom->Prev = NULL;
    EntryBottom->Action = NULL;
    EntryBottom->ID = 0;

    FreeTop = &( _ActionList[ ActionMax + 1 ] );
    FreeTop->Next = NULL;
    FreeTop->Prev = NULL;
    FreeTop->Action = NULL;
    FreeTop->ID = 0;

    for ( int i=ActionMax; i>=1; i-- ) {
    ActionListNode*   node = &( _ActionList[ i ] );

        node->ID = i;
        InitNode( node );
    }
}


ActionList::~ActionList( void )
{
#ifdef _DEBUG
    if ( Current ) {
        // Warning Something ...
    }
#endif /* _DEBUG */

    delete  []  _ActionList;
}


void    ActionList::Execute( void )
{
    Current = _ActionList[ 0 ].Next;
    while ( Current ) {
        ( Current->Action )();
        Current = Current->Next;
    }
}


ActionListID  ActionList::Entry(
    void    ( *action )( void ) )
{
ActionListNode*   node = FreeTop;

    FreeTop = FreeTop->Next;

    node->Action = action;
    node->Prev   = EntryBottom;
    node->Next   = NULL;

    EntryBottom->Next = node;
    EntryBottom       = node;

    return( node->ID );
}


void    ActionList::Delete(
    ActionListID  id )
{
ActionListNode*   node = &( _ActionList[ id ] );

    node->Prev->Next = node->Next;
    if ( node->Next ) {
        node->Next->Prev = node->Prev;
    }
    else {
        EntryBottom = node->Prev;
    }

    if( node == Current ){
        Current = node->Prev;
    }

    InitNode( node );
}

